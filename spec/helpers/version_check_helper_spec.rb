require 'spec_helper'

describe VersionCheckHelper do
  describe '#version_status_badge' do
    it 'should return nil if not dev environment and not enabled' do
      allow(Rails.env).to receive(:production?) { false }
      allow(Gitlab::CurrentSettings.current_application_settings).to receive(:version_check_enabled) { false }

      expect(helper.version_status_badge).to be(nil)
    end

    context 'when production and enabled' do
      before do
        allow(Rails.env).to receive(:production?) { true }
        allow(Gitlab::CurrentSettings.current_application_settings).to receive(:version_check_enabled) { true }
        allow(VersionCheck).to receive(:url) { 'https://version.host.com/check.svg?gitlab_info=xxx' }
      end

      it 'should return an image tag' do
        expect(helper.version_status_badge).to start_with('<img')
      end

      it 'should have a js prefixed css class' do
        expect(helper.version_status_badge)
          .to match(/class="js-version-status-badge lazy"/)
      end

      it 'should have a VersionCheck url as the src' do
        expect(helper.version_status_badge)
          .to include(%{src="https://version.host.com/check.svg?gitlab_info=xxx"})
      end
    end
  end
end
