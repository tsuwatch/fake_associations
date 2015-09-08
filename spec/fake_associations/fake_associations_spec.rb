require 'spec_helper'

describe FakeAssociations do
  class User
    include ActiveModel::Model
    include FakeAssociations

    attr_accessor :id

    has_many :posts
    has_many :favorites

    has_many :favorites_posts, through: :favorites, source: :post
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
        let!(:post) { Post.create(user_id: user.id) }

        it 'returns post object' do
          expect(user.posts).to eq [post]
        end

        context 'using through and source options' do
          it 'defines association' do
            expect(user).to be_respond_to(:favorites_posts)
          end

          describe 'association' do
            let!(:favorites) do
              Favorite.create(user_id: user.id, post_id: post.id)
            end

            it 'returns favorite posts object' do
              expect(user.favorites_posts).to eq [post]
            end
          end
        end
      end
    end
  end
end
