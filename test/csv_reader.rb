require 'test/unit'
require 'lib/csv_reader'

class TestCsvReader < Test::Unit::TestCase

  def test_has_class
   assert CsvReader.is_a?(Class), 'Class CsvReader not defined!'
  end

  def test_make_instances
   assert_raise(CsvFileMissing) { CsvReader.new('invalid_file_name.csv') }
   assert_not_nil CsvReader.new('sample/sample.csv')
  end
  
  def test_read_titles
    sample = CsvReader.new('sample/sample.csv')
    assert sample.titles == ['nome', 'idade', 'sexo'], 'Validando os titulos'
  end  

  def test_read_one
    sample = CsvReader.new('sample/sample.csv')
    line = sample.read_one

    assert_kind_of OpenStruct, line, 'Não foi gerado um OpenStruct'

    assert_not_nil line.nome, "Nome não está presente"
    assert_not_nil line.idade, "Idade não está presente"
    assert_not_nil line.sexo, "Sexo não está presente"
  end
  
  def test_have_line
    sample = CsvReader.new('sample/sample.csv')
    3.times { sample.read_one }
    assert_raise(NoMoreLines, 'Erro de final do arquivo') { sample.read_one }
  end

  def test_read_empty_file
    assert_raise(EmptyCsvFile) { CsvReader.new('sample/empty.csv') }
  end

  def test_read_all
    sample = CsvReader.new('sample/sample.csv')
    collection = sample.read_all
    assert collection.length == 3, "Erro no tamanho da coleção"
  end

end
