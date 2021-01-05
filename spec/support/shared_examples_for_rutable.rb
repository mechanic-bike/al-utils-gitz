shared_examples_for 'rutable' do

  it { expect(subject).to respond_to(:rut) }

  describe 'Validations' do
    it 'accepts valid rut' do
      expect(subject).to allow_value('170219074').for(:rut)
    end

    it 'accepts valid rut when check digit is "k"' do
      expect(subject).to allow_value('14759478k').for(:rut)
    end

    it 'accepts enterprise rut' do
      expect(subject).to allow_value('765404371').for(:rut)
    end

    it 'rejects invalid check digit' do
      expect(subject).to_not allow_value('170219073').for(:rut)
    end

    it 'rejects invalid rut' do
      expect(subject).to_not allow_value('1702190k7').for(:rut)
    end
  end

  describe 'Callbacks' do
    it 'calls unformat_rut before validations' do
      expect(subject).to receive(:unformat_rut!)
      subject.valid?
    end
  end

  describe 'Methods' do
    before { subject.rut = '765404371' }

    it 'unformat rut on assign' do
      subject.rut = '76.027.202-7'
      expect(subject.rut).to be == '760272027'
    end

    it 'shows formatted rut' do
      expect(subject.formatted_rut).to be == '76.540.437-1'
    end

    it 'shows unformatted rut' do
      expect(subject.unformatted_rut).to be == '765404371'
    end

    it 'shows simple formatted rut' do
      expect(subject.simple_formatted_rut).to be == '76540437-1'
    end
  end

end