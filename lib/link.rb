# Класс «Link», разновидность базового класса «Post»
class Link < Post
  def initialize
    super
    @url = ''
  end

  def load_data(data_hash)
    # Сперва дергаем родительский метод load_data для общих полей. Обратите внимание, что вызов без параметров
    # тут эквивалентен super(data_hash), так как те же параметры будут переданы методу super автоматически.
    super
    # Теперь достаем из хэша специфичное только для ссылки значение url
    @url = data_hash['url']
  end

  def read_from_console
    puts 'Адрес ссылки (url):'
    @url = $stdin.gets.chomp
    puts 'Что за ссылка?'
    @text = $stdin.gets.chomp
  end

  def to_db_hash
    super.merge(
      {
        'text' => @text,
        'url' => @url
      }
    )
  end

  def to_string
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n"

    [@url, @text, time_string]
  end
end
