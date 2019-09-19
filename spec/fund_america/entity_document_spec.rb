require 'spec_helper'

describe FundAmerica::EntityDocument, :vcr_preserve_exact_body_bytes do
  context '#list' do
    let(:response) { described_class.list(entity['id']) }

    context 'entity with document exists' do
      let(:entity) { create_entity }
      let(:entity_document) { create_entity_document(entity) }

      before { entity_document }

      it 'returns entities list' do
        expect(response['object']).to eq 'resource_list'
        expect(response['total_resources']).to eq 1
        expect(response['resources'].first['id']).to eq entity_document['id']
        expect(response['resources'].first['object']).to eq 'entity_document'
      end
    end

    context 'entity does not exist' do
      let(:entity) { { 'id' => 'XXX' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#create' do
    let(:response) { described_class.create(params) }

    context 'when valid params' do
      let(:params) { entity_document_params }

      it 'returns created entity document' do
        expect(response['object']).to eq 'entity_document'
        expect(response['id']).not_to be_empty
        expect(response['entity_url']).to include params[:entity_id]
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

  context '#details' do
    let(:response) { described_class.details(entity_document['id']) }

    context 'entity document exists' do
      let(:entity_document) { create_entity_document }

      it 'returns entity details' do
        expect(response['object']).to eq 'entity_document'
        expect(response['id']).to eq entity_document['id']
      end
    end

    context 'entity document does not exist' do
      let(:entity_document) { { 'id' => 'XXX' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end
end
