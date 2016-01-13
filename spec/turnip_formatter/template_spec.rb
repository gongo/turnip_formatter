require 'spec_helper'
require 'tempfile'

describe TurnipFormatter::Template do
  let(:template) { described_class }

  let(:local_js_path) do
    Tempfile.open('local.js') do |f|
      f.write('alert("local!");')
      f.path
    end
  end

  let(:local_css_path) do
    Tempfile.open('local.css') do |f|
      f.write('body { color: green; }')
      f.path
    end
  end

  let(:remote_js_path) { 'http://example.com/foo.js' }
  let(:remote_css_path) { 'http://example.com/foo.css' }

  before do
    template.reset!
  end

  describe '.render_javascript_codes' do
    subject { template.render_javascript_codes }

    before do
      template.add_javascript(path)
    end

    context 'added local javascript file' do
      let(:path) { local_js_path }
      it { should include 'alert("local!");' }
    end

    context 'add remote javascript file' do
      let(:path) { remote_js_path }
      it { should be_empty }
    end
  end

  describe '.render_javascript_links' do
    subject { template.render_javascript_links }

    before do
      template.add_javascript(path)
    end

    context 'added local javascript file' do
      let(:path) { local_js_path }
      it { should be_empty }
    end

    context 'add remote javascript file' do
      let(:path) { remote_js_path }
      it { should include %Q(<script src="#{path}"></script>) }
    end

    context 'add remote javascript file (no schema)' do
      let(:path) { '//example.com/foo.js' }
      it { should include %Q(<script src="#{path}"></script>) }
    end

    context 'add incorrect uri' do
      let(:path) { 'http://e xample.com/foo.js' }
      it { should be_empty }
    end
  end

  describe '.render_stylesheet_codes' do
    subject { template.render_stylesheet_codes }

    before do
      template.add_stylesheet(path)
    end

    context 'added local stylesheet file' do
      let(:path) { local_css_path }
      it { should include 'body { color: green; }' }
    end

    context 'add remote stylesheet file' do
      let(:path) { remote_css_path }
      it { should be_empty }
    end
  end

  describe '.render_stylesheet_links' do
    subject { template.render_stylesheet_links }

    before do
      template.add_stylesheet(path)
    end

    context 'added local stylesheet file' do
      let(:path) { local_js_path }
      it { should be_empty }
    end

    context 'add remote stylesheet file' do
      let(:path) { remote_css_path }
      it { should include %Q(<link rel="stylesheet" href="#{path}">) }
    end

    context 'add remote stylesheet file (no schema)' do
      let(:path) { '//example.com/foo.css' }
      it { should include %Q(<link rel="stylesheet" href="#{path}">) }
    end

    context 'add incorrect uri' do
      let(:path) { 'http://e xample.com/foo.css' }
      it { should be_empty }
    end
  end
end
