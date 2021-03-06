require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do
  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!)
    allow(request.env['warden']).to receive(:user).and_return(user)
  end

  let(:user) do
    create(:user)
  end

  let(:valid_attributes) do
    { url: 'http://google.com/image.jpg' }
  end

  let(:invalid_attributes) do
    { path: 'bananas' }
  end

  let(:valid_session) do
  end

  describe 'GET #index' do
    it 'assigns all images as @images' do
      image = create(:image)
      get :index, { format: 'json' }, valid_session
      expect(assigns(:images)).to eq([image])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested image as @image' do
      image = create(:image)
      get :show, { id: image.to_param, format: 'json' }, valid_session
      expect(assigns(:image)).to eq(image)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      render_views

      it 'creates a new Image' do
        expect do
          post :create, { image: valid_attributes, format: 'json' },
               valid_session
        end.to change(Image, :count).by(1)
      end

      it 'assigns a newly created image as @image' do
        post :create, { image: valid_attributes, format: 'json' },
             valid_session
        expect(assigns(:image)).to be_a(Image)
        expect(assigns(:image)).to be_persisted
      end

      it 'returns status :created' do
        post :create,
             { image: valid_attributes, format: 'json' },
             valid_session

        expect(response).to have_http_status(:created)
      end

      it 'returns the created image' do
        post :create,
             { image: valid_attributes, format: 'json' },
             valid_session

        result = JSON.parse(response.body)
        expect(result['image_url']).to be_present
        expect(result['id']).to be_present
        expect(result['user_id']).to eq(user.id)
      end
    end

    context 'with invalid params' do
      it 'does not create new image' do
        expect do
          post :create, { image: invalid_attributes, format: 'json' },
               valid_session
        end.not_to change(Image, :count)
      end

      it 'returns status :unprocessable_entity' do
        post :create, { image: invalid_attributes, format: 'json' },
             valid_session
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'shows an error' do
        post :create, { image: invalid_attributes, format: 'json' },
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
        { url: 'http://google.com/new.jpg' }
      end

      it 'updates the requested image' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: new_attributes, format: 'json' },
            valid_session
        image.reload

        expect(image.url).to eq('http://google.com/new.jpg')
      end

      it 'assigns the requested image as @image' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: valid_attributes, format: 'json' },
            valid_session
        expect(assigns(:image)).to eq(image)
      end

      it 'has status :no_content' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: valid_attributes, format: 'json' },
            valid_session
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid params' do
      let(:new_invalid_attributes) do
        { user_id: 0 }
      end

      it 'assigns the image as @image' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: new_invalid_attributes,
              format: 'json' },
            valid_session
        expect(assigns(:image)).to eq(image)
      end

      it 'does not change invalid attribute' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: new_invalid_attributes,
              format: 'json' },
            valid_session
        image.reload

        expect(image.user_id).not_to eq(0)
      end

      it 'have status :unprocessable_entity' do
        image = create(:image)
        put :update,
            { id: image.to_param, image: new_invalid_attributes,
              format: 'json' },
            valid_session

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested image' do
      image = create(:image)
      expect do
        delete :destroy, { id: image.to_param, format: 'json' }, valid_session
      end.to change(Image, :count).by(-1)
    end

    it 'has status :no_content' do
      image = create(:image)
      delete :destroy, { id: image.to_param, format: 'json' }, valid_session

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'permissions' do
    let(:owner) { create(:user) }
    let(:image) { create(:image, user: owner) }
    let(:delete_content) { { id: image.to_param, format: 'json' } }
    let(:put_content) do
      { id: image.to_param, image: valid_attributes, format: 'json' }
    end
    let(:post_content) { { image: valid_attributes, format: 'json' } }
    let(:show_content) { { id: image.to_param, format: 'json' } }

    context 'guest' do
      before(:each) do
        warden = request.env['warden']
        allow(warden).to receive(:user).with(:guest).and_return({})
        allow(warden).to receive(:user).with(:user).and_return(nil)
        allow(warden).to receive(:user).with(:admin).and_return(nil)
      end

      it 'can #index' do
        get :index, { format: 'json' }, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #show' do
        get :show, show_content, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'cannot #create' do
        post :create, post_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot #update' do
        put :update, put_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot #destroy' do
        delete :destroy, delete_content, valid_session
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

      it 'can #index' do
        get :index, { format: 'json' }, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #show' do
        get :show, show_content, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #update' do
        put :update, put_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #destroy' do
        delete :destroy, delete_content, valid_session
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

      it 'can #index' do
        get :index, { format: 'json' }, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #show' do
        get :show, show_content, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #update' do
        put :update, put_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #destroy' do
        delete :destroy, delete_content, valid_session
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

      it 'can #index' do
        get :index, { format: 'json' }, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #show' do
        get :show, show_content, valid_session

        expect(response).not_to have_http_status(:forbidden)
      end

      it 'can #create' do
        post :create, post_content, valid_session
        expect(response).not_to have_http_status(:forbidden)
      end

      it 'cannot #update' do
        put :update, put_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot #destroy' do
        delete :destroy, delete_content, valid_session
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
