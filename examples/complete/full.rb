require 'hopscotch'
require 'json'

class Job1 < Hopscotch::Job
  consumes 'ldap.loadUser'
  produces 'ldap.userData', 'app.userData'

  use_logging_topic 'hopscotch.system.logger.job'

  def run(message)
    logger.info('Job1 has received a message')
    puts "Job1 has received a message: #{message}"
    sleep(10)
    :ack
  end

end

class Job2 < Hopscotch::Job
  consumes 'ldap.userData'

  def run(message)
    logger.info('Job2 has received a message')
    puts "Job2 has received a message: #{message}"
    sleep(10)
    :reject
  end
end

class MyWorkflow < Hopscotch::Workflow
  produces 'ldap.loadUser'

  use_job Job1
  use_job Job2

  def run(params: {})
    queue_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.userData', Hopscotch::Message.new('ldap.userData', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.userData', Hopscotch::Message.new('ldap.userData', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.userData', Hopscotch::Message.new('ldap.userData', '0.1.0', data: {hello: 'world'}))
    queue_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.userData', Hopscotch::Message.new('ldap.userData', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.userData', Hopscotch::Message.new('ldap.userData', '0.1.0', data: {hello: 'world'}))
    publish_message( 'ldap.loadUser', Hopscotch::Message.new('ldap.loadUser', '0.1.0', data: {hello: 'world'}))
  end
end
