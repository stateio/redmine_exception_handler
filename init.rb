require 'redmine'

# Dir[File.join(Redmine::Plugin.directory,'redmine_exception_handler','vendor','plugins','*')].each do |dir|
#   path = File.join(dir, 'lib')
#   $LOAD_PATH << path
#   ActiveSupport::Dependencies.autoload_paths << path
# end

Redmine::Plugin.register :redmine_exception_handler do
  name 'Redmine Exception Handler plugin'
  author 'Eric Davis'
  description 'Send emails when exceptions occur in Redmine.'
  version '1.0.0'
  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    'exception_handler_recipients' => 'phillmv@okayfail.com',
    'exception_handler_sender_address' => 'RDQ3 Exception <noreply@rdq.tdlab.ca>',
    'exception_handler_prefix' => "[RDQ3 #{Rails.env}]",
    'exception_handler_email_format' => 'text'
  }, :partial => 'settings/exception_handler_settings'
  
end

require_dependency 'exception_notification'
ExceptionNotifier::Notifier.send(:include, ExceptionHandler::RedmineNotifierPatch)

RedmineApp::Application.config.middleware.use ExceptionNotifier
