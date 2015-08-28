require 'spec_helper'

describe FakeAssociations do
  class User
    include ActiveModel::Model
    include FakeAssociations

    attr_accessor :id

    has_many :posts
  end

  describe 'has_many' do
    it 'Add has_many method' do
      expect(User).to be_respond_to(:has_many)
    end

    describe '.has_many' do
      let(:user) { User.new(id: 1) }

      it 'defines association' do
        expect(user).to be_respond_to(:posts)
      end

      describe 'association' do
        let(:user) { User.new(id: 1) }
        let!(:post) { Post.create(user_id: user.id) }

        it 'returns ActiveRecord object' do
          expect(user.posts.first).to eq post
        end
      end
    end
  end
end
