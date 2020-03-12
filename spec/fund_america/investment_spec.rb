require 'spec_helper'

describe FundAmerica::Investment, :vcr do
  context '#list' do
    let(:response) { described_class.list }

    it 'returns investments list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to be > 1
      expect(response['resources'].first['object']).to eq 'investment'
    end
  end

  context '#create' do
    let(:response) { described_class.create(params) }

    context 'when valid params' do
      let(:params) { investment_params }

      it 'returns created investment' do
        expect(response['object']).to eq('investment')
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

  context '#update' do
    let(:params) { { status: 'received' } }
    let(:response) { described_class.update(investment['id'], params) }

    context 'when investment exists and params are valid' do
      let(:investment) { create_investment }

      it 'returns updated investment' do
        expect(response['id']).to eq investment['id']
        expect(response['status']).to eq params[:status]
      end

      it 'updates investment' do
        expect(investment['status']).not_to eq params[:status]
        response
        reloaded_investment = described_class.details(investment['id'])
        expect(reloaded_investment['status']).to eq params[:status]
      end
    end
  end

  context '#details' do
    let(:investment_id) { 'uP0DmH10Rdiw6V6pUNlbzA' }
    let(:response) { described_class.details(investment_id) }

    it 'returns investment details' do
      expect(response['object']).to eq 'investment'
      expect(response['id']).to eq investment_id
    end
  end

  context '#delete' do
    let(:response) { described_class.delete(investment['id']) }
    let(:investment) { create_investment }

    context 'when delete passed with success' do
      it 'returns investment' do
        expect(response['id']).to eq(investment['id'])
      end

      it 'returns investment with changed status to voided' do
        expect(response['status']).to eq('voided')
      end
    end

    context 'when investment is deleted' do
      before { described_class.delete(investment['id']) }

      it 'returns nil' do
        expect(response).to be_nil
      end
    end

    context 'when investment does not exists' do
      let(:investment) { { 'id' => 'abc' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#billing_logs' do
    let(:investment_id) { 'uP0DmH10Rdiw6V6pUNlbzA' }
    let(:response) { described_class.billing_logs(investment_id) }

    it 'returns empty list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to eq(0)
      expect(response['resources']).to be_empty
    end
  end

  context '#investment_payments' do
    let(:investment_id) { 'uP0DmH10Rdiw6V6pUNlbzA' }
    let(:response) { described_class.investment_payments(investment_id) }

    it 'returns empty list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to eq(0)
      expect(response['resources']).to be_empty
    end
  end

  # There is manually updated cassette for this test
  context '#investment_payments' do
    let(:investment_id) { 'uP0DmH10Rdiw6V6pUNlbzA' }
    let(:response) { described_class.crypto_wallets(investment_id) }

    it 'returns crypto wallets list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to be >= 1
      expect(response['resources'].first['object']).to eq 'crypto_wallet'
      expect(response['resources'].first['address']).to eq '32bZhdXJmWV1fbfd2HS6SNnpA1fqawcfC7'
    end
  end
end
