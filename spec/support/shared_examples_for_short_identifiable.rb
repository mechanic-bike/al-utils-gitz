shared_examples_for 'short_identifiable' do

  it { is_expected.to respond_to(:uuid) }

  context 'Validations' do
    it { is_expected.to allow_value('AA1234').for(:uuid) }

    it 'rejects lower case chars' do
      is_expected.not_to allow_value('Aa1234').for(:uuid)
    end

    it 'rejects symbols chars' do
      is_expected.not_to allow_value('AA123$').for(:uuid)
    end
  end

  context 'Callbacks' do
    it 'calls generate_uuid when object is created' do
      is_expected.to receive(:generate_uuid)
      subject.save
    end
  end

  context 'Methods' do
    it 'uuid cannot be able to update' do
      subject.uuid = 'AA1111'
      subject.save
      subject.uuid = 'ZZ9999'
      expect(subject.uuid).to eq('AA1111')
    end
  end

end