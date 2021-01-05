shared_examples_for 'slugable' do

  it { expect(subject).to respond_to(:slug) }
  it { expect(subject).to respond_to(:title).or respond_to(:name) }

  describe 'Callbacks' do
    it 'calls set_slug before create' do
      expect(subject).to be_a_new(subject.class)
      expect(subject).to receive(:set_slug)
      subject.save
    end

    it 'Don\'t call set_slug when save persisted record' do
      subject.save
      expect(subject).to be_persisted
      expect(subject).not_to receive(:set_slug)
      subject.slug = 'test-slug'
      subject.save
    end
  end

end