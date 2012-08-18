require File.expand_path('../../lib/dj_mailer', __FILE__)


def with_stub_const(const, value)
  if Object.const_defined?(const)
    begin
      @const = const
      Object.const_set(const, value)
      yield
    ensure
      Object.const_set(const, @const)
    end
  else
    begin
      Object.const_set(const, value)
      yield
    ensure
      Object.send(:remove_const, const)
    end
  end
end

def with_excluded_environments(envs)
  DjMailer::Delayable.excluded_environments = envs
  yield
ensure
  DjMailer::Delayable.excluded_environments = []
end