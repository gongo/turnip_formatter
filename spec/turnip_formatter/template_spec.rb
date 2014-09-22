require 'spec_helper'

describe TurnipFormatter::Template do
  let(:template) { described_class }

  before do
    template.reset!
  end

  describe '.add_javascript' do
    let(:js_codes) { template.render_javascript_codes }
    let(:js_links) { template.render_javascript_links }

    before do
      template.add_javascript(path)
    end

    context 'add local javascript file' do
      let(:path) do
        Tempfile.open('local.js') do |f|
          f.write('alert("local!");')
          f.path
        end
      end

      it do
        expect(js_codes).to include 'alert("local!");'
      end
    end

    context 'add remote javascript file' do
      let(:path) { 'http://example.com/foo.js' }

      it do
        expect(js_links).to include %Q(<script src="#{path}" type="text/javascript"></script>)
      end
    end

    context 'add incorrect remote javascript file' do
      let(:path) { 'http://e_xample.com/foo.js' }

      it { expect(js_links).to eq '' }
    end
  end

  describe '.add_stylesheet' do
    let(:css_codes) { template.render_stylesheet_codes }
    let(:css_links) { template.render_stylesheet_links }

    before do
      template.add_stylesheet(path)
    end

    context 'add local stylesheet file' do
      let(:path) do
        Tempfile.open('local.css') do |f|
          f.write('body { color: green; }')
          f.path
        end
      end

      it do
        expect(css_codes).to include 'body { color: green; }'
      end
    end

    context 'add remote stylesheet file' do
      let(:path) { 'http://example.com/foo.css' }

      it do
        expect(css_links).to include %Q(<link rel="stylesheet" href="#{path}">)
      end
    end

    context 'add incorrect remote stylesheet file' do
      let(:path) { 'http://e_xample.com/foo.css' }

      it { expect(css_links).to eq '' }
    end
  end
end
