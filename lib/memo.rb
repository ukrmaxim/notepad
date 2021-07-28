# Класс «Memo», разновидность базового класса «Post»
class Memo < Post
  # Отдельный конструктор здесь не нужен, т. к. у заметки нет дополнительных переменных экземпляра.

  # Метод load_data у Memo считывает дополнительно text заметки
  def load_data(data_hash)
    # Сперва дергаем родительский метод load_data для общих полей. Обратите внимание, что вызов без параметров
    # тут эквивалентен super(data_hash), так как те же параметры будут переданы методу super автоматически.
    super
    # Теперь достаем из хэша специфичное только для задачи значение text
    @text = data_hash['text'].split('\n')
  end

  def read_from_console
    puts 'Новая заметка (все, что пишите до строчки "end"):'

    # Для старта цикла запишем в переменную line nil
    line = nil

    # Пока в переменной line не окажется слово «end», крутимся в цикле и считываем строку за строкой в массив @text.
    until line == 'end'
      line = $stdin.gets.chomp
      @text << line
    end

    # Удалим последний элемент из массива @text — там служебное слово «end», которое мы не хотим видеть в нашей заметке.
    @text.pop
  end

  def to_db_hash
    super.merge(
      {
        'text' => @text.join('\n')
      }
    )
  end

  def to_string
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"

    # Возвращаем массив @text с добавление в начало (методом массива unshift) строчки с датой создания заметки.
    @text.unshift(time_string)
  end
end
