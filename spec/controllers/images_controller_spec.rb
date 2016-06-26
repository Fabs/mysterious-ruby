require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all images as @images" do
      image = Image.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:images)).to eq([image])
    end
  end

  describe "GET #show" do
    it "assigns the requested image as @image" do
      image = Image.create! valid_attributes
      get :show, {:id => image.to_param}, valid_session
      expect(assigns(:image)).to eq(image)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, {:image => valid_attributes}, valid_session
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, {:image => valid_attributes}, valid_session
        expect(assigns(:image)).to be_a(Image)
        expect(assigns(:image)).to be_persisted
      end

      it "redirects to the created image" do
        post :create, {:image => valid_attributes}, valid_session
        expect(response).to redirect_to(Image.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        post :create, {:image => invalid_attributes}, valid_session
        expect(assigns(:image)).to be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        post :create, {:image => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested image" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => new_attributes}, valid_session
        image.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested image as @image" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => valid_attributes}, valid_session
        expect(assigns(:image)).to eq(image)
      end

      it "redirects to the image" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => valid_attributes}, valid_session
        expect(response).to redirect_to(image)
      end
    end

    context "with invalid params" do
      it "assigns the image as @image" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => invalid_attributes}, valid_session
        expect(assigns(:image)).to eq(image)
      end

      it "re-renders the 'edit' template" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested image" do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, {:id => image.to_param}, valid_session
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      image = Image.create! valid_attributes
      delete :destroy, {:id => image.to_param}, valid_session
      expect(response).to redirect_to(images_url)
    end
  end

end
