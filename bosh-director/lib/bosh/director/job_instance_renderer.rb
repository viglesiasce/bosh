module Bosh::Director
  class JobInstanceRenderer
    def initialize(job, job_template_loader)
      @job = job
      @job_template_loader = job_template_loader
    end

    def render(instance)
      job.templates.map do |template|
        job_template_renderer = job_template_renderers[template.name]
        job_template_renderer.render(job.name, instance)
      end
    end

    private

    def job_template_renderers
      @job_template_renderers ||= job.templates.reduce({}) do |hash, template|
        hash[template.name] = job_template_loader.process(template)
        hash
      end
    end

    attr_reader :job_template_loader, :job
  end
end
