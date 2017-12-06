describe Manabu::Students do
  context '.new' do
    it 'creates a blank Student template' do
      student = Manabu::Student.new
      expect(student.name).to be(nil)
      expect(student.id).to be(nil)
    end

    it 'fills student object attrs with an initializing hash' do
      student = Manabu::Student.new(name: 'a', surname: 'b')
      expect(student.name).to eq('a')
      expect(student.id).to be(nil)
    end
  end

  context '.fill' do
    it 'fills details by lambda' do
      student = Manabu::Student.new
      expect(student.name).to eq(nil)
      expect(student.id).to eq(nil)

      student.fill(id: 0)
      expect(student.name).to eq(nil)
      expect(student.id).to eq(0)

      student.fill(name: 'test')
      expect(student.name).to eq('test')
      expect(student.id).to eq(0)
    end
  end
end
