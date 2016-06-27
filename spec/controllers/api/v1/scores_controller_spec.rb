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
      let(:score) { create(:score, value: 2) }
      let(:new_attributes) do
        { value: 3 }
      end

      it 'updates the requested score' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_attributes, format: 'json' },
            valid_session
        score.reload

        expect(score.value).to eq(3)
      end

      it 'assigns the requested score as @score' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_attributes, format: 'json' },
            valid_session

        expect(assigns(:score)).to eq(score)
      end

      it 'has status :no_content' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_attributes, format: 'json' },
            valid_session

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid params' do
      let(:score) { create(:score) }
      let(:new_invalid_attributes) do
        { image_id: 0 }
      end

      it 'assigns the score as @score' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_invalid_attributes,
              format: 'json' },
            valid_session

        expect(assigns(:score)).to eq(score)
      end

      it 'does not change invalid attribute' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_invalid_attributes,
              format: 'json' },
            valid_session
        score.reload

        expect(score.user_id).not_to eq(0)
      end

      it 'have status :unprocessable_entity' do
        put :update,
            { image_id: score.image_id,
              id: score.to_param, score: new_invalid_attributes,
              format: 'json' },
            valid_session

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'permissions' do
    let(:owner) { create(:user) }
    let(:score) { create(:score, user: owner) }
    let(:image) { score.image }
    let(:put_content) do
      { image_id: image.id, id: score.to_param, score: valid_attributes,
        format: 'json' }
    end

    let(:post_content) do
      { image_id: image.id, score: valid_attributes, format: 'json' }
    end

    context 'guest' do
      before(:each) do
        warden = request.env['warden']
        allow(warden).to receive(:user).with(:guest).and_return({})
        allow(warden).to receive(:user).with(:user).and_return(nil)
        allow(warden).to receive(:user).with(:admin).and_return(nil)
      end

      it 'cannot #create' do
        post :create, post_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot #update' do
        put :update, put_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'admin' do
      before(:each) do
        warden = request.env['warden']
        user = create(:user, admin: true)
        allow(warden).to receive(:user).with(:guest).and_return({})
        allow(warden).to receive(:user).with(:user).and_return(user)
        allow(warden).to receive(:user).with(:admin).and_return(user)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #update' do
        put :update, put_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end
    end

    context 'owner' do
      before(:each) do
        warden = request.env['warden']
        allow(warden).to receive(:user).with(:guest).and_return({})
        allow(warden).to receive(:user).with(:user).and_return(owner)
        allow(warden).to receive(:user).with(:admin).and_return(nil)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #update' do
        put :update, put_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end
    end

    context 'user' do
      before(:each) do
        warden = request.env['warden']
        user = create(:user)
        allow(warden).to receive(:user).with(:guest).and_return({})
        allow(warden).to receive(:user).with(:user).and_return(user)
        allow(warden).to receive(:user).with(:admin).and_return(nil)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'cannot #update' do
        put :update, put_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
