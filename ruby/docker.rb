require 'block-is-array'
require 'dockerfile-dsl'
require 'rake/clean'

require_relative '../config'



def docker_tasks image, run_options='', &block
  create_dockerfile(&block)

  image = File.join DOCKER_USER.to_s, image.to_s

  task_run image, run_options
  task_rm image
  task_rerun
  task_push image

  task :default => :build
end

def create_dockerfile &block
  array = block_is_array(&block)

  if array[0][0] != :from
    array.insert 0, [:from, DEFAULT_BASE_IMAGE]
  end

  if array.map{ |entry| entry[0] != :maintainer }.all?
    array.insert 1, [:maintainer, MAINTAINER]
  end

  File.write 'Dockerfile', Dockerfile::from_array(array)
end

def task_build image
  task :build do
    sh %Q(sudo docker build -t #{image} .)
  end
end

def task_push image
  task :push do
    sh %Q(sudo docker push #{image})
  end
end

def task_run image, options
  task_build image

  task :run => :build do
    hostname = [File.basename(image), '.', `hostname`.strip].join
    sh %Q(sudo docker run -itd -h #{hostname} --name #{hostname} #{options} \
                          #{image})
  end
end

def task_rerun
  task :rerun => :rm do
    Rake::Task[:run].invoke
  end
end

def docker_subcommand_on_image subcommand, image, another_grep=:cat
  containers = `sudo docker ps -a | grep #{image} | #{another_grep} | \
                awk '{print $1}'`.gsub "\n", ' '
  %Q(sudo docker #{subcommand} #{containers}) if containers.strip.length > 0
end

def task_rm image
  task_stop image

  task :rm => :stop do
    maybe_sh docker_subcommand_on_image(:rm, image)
  end
end

def task_stop image
  task :stop do
    maybe_sh docker_subcommand_on_image(:stop, image, 'grep -v Exited')
  end
end

def maybe_sh command
  sh command if command
end


CLEAN.include Dir.glob('Dockerfile')
