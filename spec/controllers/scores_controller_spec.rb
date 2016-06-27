require 'rails_helper'

RSpec.describe Api::V1::ScoresController, type: :controller do
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all scores as @scores' do
      score = Score.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:scores)).to eq([score])
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Score' do
        expect do
          post :create, { score: valid_attributes }, valid_session
        end.to change(Score, :count).by(1)
      end

      it 'assigns a newly created score as @score' do
        post :create, { score: valid_attributes }, valid_session
        expect(assigns(:score)).to be_a(Score)
        expect(assigns(:score)).to be_persisted
      end

      it 'redirects to the created score' do
        post :create, { score: valid_attributes }, valid_session
        expect(response).to redirect_to(Score.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved score as @score' do
        post :create, { score: invalid_attributes }, valid_session
        expect(assigns(:score)).to be_a_new(Score)
      end

      it 're-renders the :new template' do
        post :create, { score: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested score' do
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: new_attributes },
            valid_session
        score.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested score as @score' do
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: valid_attributes },
            valid_session
        expect(assigns(:score)).to eq(score)
      end

      it 'redirects to the score' do
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: valid_attributes },
            valid_session
        expect(response).to redirect_to(score)
      end
    end

    context 'with invalid params' do
      it 'assigns the score as @score' do
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: invalid_attributes },
            valid_session
        expect(assigns(:score)).to eq(score)
      end

      it 're-renders the :edit template' do
        score = Score.create! valid_attributes
        put :update,
            { id: score.to_param, score: invalid_attributes },
            valid_session
        expect(response).to render_template('edit')
      end
    end
  end
end
