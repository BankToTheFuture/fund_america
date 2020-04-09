require 'spec_helper'

describe FundAmerica::AchAuthorization, :vcr do
  context '#create' do
    let(:response) { described_class.create(params) }

    context 'when valid params' do
      let(:params) { ach_authorization_params }

      it 'returns created ach_authorization' do
        expect(response['object']).to eq 'ach_authorization'
        expect(response['id']).not_to be_empty
      end
    end

    context 'when invalid params' do
      let(:params) { {} }

      it 'raises error' do
        error = /invalid parameters/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#agreement_html' do
    let(:response) { described_class.agreement_html }

    it 'returns agreement_html' do
      expect(response['agreement_html']).not_to be_empty
    end
  end
end
