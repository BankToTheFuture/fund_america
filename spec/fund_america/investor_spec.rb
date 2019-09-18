require 'spec_helper'

describe FundAmerica::Investor, :vcr do
  context '#list' do
    let(:response) { described_class.list }

    it 'returns investors list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to be > 1
      expect(response['resources'].first['object']).to eq 'investor'
    end
  end

  context '#details' do
    let(:investor) { create_investor }
    let(:response) { described_class.details(investor['id']) }

    it 'returns investor details' do
      expect(response['object']).to eq 'investor'
      expect(response['id']).to eq investor['id']
    end
  end

  context '#create' do
    let(:response) { described_class.create(params) }

    context 'when valid params' do
      let(:entity) { create_entity }
      let(:params) { { primary_entity_id: entity['id'] } }

      it 'returns created investor' do
        expect(response['object']).to eq 'investor'
        expect(response['id']).not_to be_empty
        expect(response['entity_urls'][0]).to include entity['id']
      end
    end

    context 'when invalid params' do
      let(:params) { { primary_entity_id: 'xxx' } }

      it 'raises error' do
        error = /invalid parameters/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#update' do
    let(:response) { described_class.update(investor['id'], params) }
    let(:params) do
      {
        accreditation_type: 'individual_net_worth',
        accredited: true
      }
    end

    context 'when investor exists and params are valid' do
      let(:investor) { create_investor }

      it 'returns updated investor' do
        expect(response['id']).to eq investor['id']
        expect(response['accreditation_type']).to eq params[:accreditation_type]
      end

      it 'updates investor' do
        expect(investor['accreditation_type']).to eq 'non_accredited'
        response
        reloaded_investor = described_class.details(investor['id'])
        expect(reloaded_investor['accreditation_type']).to eq params[:accreditation_type]
      end
    end

    context 'when investor does not exists' do
      let(:investor) { { 'id' => 'abc' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end
end
