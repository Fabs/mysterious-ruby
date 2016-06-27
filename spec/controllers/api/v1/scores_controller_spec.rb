require 'rails_helper'

RSpec.describe Api::V1::ScoresController, type: :controller do
  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!)
    allow(request.env['warden']).to receive(:user).and_return(user)
  end

  let(:image) { create(:image) }
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { value: 1 }
  end

  let(:invalid_attributes) do
    { amount: 100 }
  end

  let(:valid_session) { {} }

  describe 'POST #create' do
    context 'with valid params' do
      render_views

      it 'creates a new Score' do
        expect do
          post :create,
               { image_id: image.id, score: valid_attributes, format: 'json' },
               valid_session
        end.to change(Score, :count).by(1)
      end

      it 'assigns a newly created score as @score' do
        post :create,
             { image_id: image.id, score: valid_attributes, format: 'json' },
             valid_session

        expect(assigns(:score)).to be_a(Score)
        expect(assigns(:score)).to be_persisted
      end

      it 'returns status :created' do
        post :create,
             { image_id: image.id, score: valid_attributes, format: 'json' },
             valid_session

        expect(response).to have_http_status(:created)
      end

      it 'returns the created score' do
        post :create,
             { image_id: image.id, score: valid_attributes, format: 'json' },
             valid_session

        result = JSON.parse(response.body)
        expect(result['value']).to be_present
        expect(result['id']).to be_present
      end
    end

    context 'with invalid params' do
      render_views

      it 'does not create new score' do
        expect do
          post :create,
               { image_id: image.id, score: invalid_attributes,
                 format: 'json' },
               valid_session
        end.not_to change(Score, :count)
      end

      it 'returns status :unprocessable_entity' do
        post :create,
             { image_id: image.id, score: invalid_attributes, format: 'json' },
             valid_session

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'shows an error' do
        post :create,
             { image_id: image.id, score: invalid_attributes, format: 'json' },
             valid_session

        result = JSON.parse(response.body)
        expect(result['errors']).to be_present
        expect(result['errors']).not_to be_empty
      end
    end

    context 'with invalid image' do
      render_views

      it 'does not create new score' do
        expect do
          post :create,
               { image_id: 0, score: invalid_attributes,
                 format: 'json' },
               valid_session
        end.not_to change(Score, :count)
      end

      it 'returns status :unprocessable_entity' do
        post :create,
             { image_id: 0, score: invalid_attributes, format: 'json' },
             valid_session

        expect(response).to have_http_status(:not_found)
      end

      it 'shows an error' do
        post :create,
             { image_id: 0, score: invalid_attributes, format: 'json' },
             valid_session

        result = JSON.parse(response.body)
        expect(result['errors']).to be_present
        expect(result['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
      end

      it 'updates the requested score' do
        pending
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: new_attributes },
            valid_session
        score.reload
      end

      it 'assigns the requested score as @score' do
        pending
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: valid_attributes },
            valid_session
        expect(assigns(:score)).to eq(score)
      end

      it 'redirects to the score' do
        pending
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: valid_attributes },
            valid_session
        expect(response).to redirect_to(score)
      end
    end

    context 'with invalid params' do
      it 'assigns the score as @score' do
        pending
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: invalid_attributes },
            valid_session
        expect(assigns(:score)).to eq(score)
      end

      it 're-renders the :edit template' do
        pending
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: invalid_attributes },
            valid_session
        expect(response).to render_template('edit')
      end
    end
  end
end
