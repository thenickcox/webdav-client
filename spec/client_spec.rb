require 'spec_helper'
require_relative '../lib/net/webdav/client'

# uncomment webmock in spec helper to enable requests

describe Net::Webdav::Client do
  let(:url)    { 'https://attachments.navigatingcancer.com/' }
  let(:path)   { 'navican-development/test1/test2/test3' }
  let(:full_url) { [url, path].join }
  let(:file)   {  'hello' }
  let(:username) { 'navican' }
  let(:password) { 'xYXNIaZSUVAVGxZHD' }
  let(:client) { Net::Webdav::Client.new(full_url, username: username, password: password) }

  describe 'put_file' do
    subject { client.put_file(full_url, file, create_file) }

    context 'path does not exist' do
      let(:create_file) { true }
      context '403' do
        let(:status) { 403 }
        let(:action) { 'creating(putting)' }
        it 'returns status code' do
          expect(subject).to raise_error
        end
      end
    end
  end

  describe '#file_exists?' do
    before do
      stub_request(:head, full_url).to_return(response_code: 404)
      Curl::Easy.http_head(full_url)
    end
    subject { client.file_exists?(full_url) }
    context 'file does not exist' do
      let(:code) { 404 }
      it { should be_false }
    end
    context 'file does exist' do
      let(:code) { 200 }
      it { should be_true }
    end
  end

end
