require 'sqlite3'

# Родительский класс «Post» — здесь мы определим основные методы и свойства, общие для всех типов записей.
class Post
  # Создаем файл базы данных и таблицу posts, если они еще не созданы
  db_file = SQLite3::Database.open 'notepad.db'
  db_file.execute 'CREATE TABLE IF NOT EXISTS posts (type TEXT, created_at NUMERIC, text TEXT, url TEXT, due_date TEXT)'
  @sqlite_db = 'notepad.db'.freeze

  # Теперь нам нужно будет читать объекты из базы данных поэтому удобнее всегда
  # иметь под рукой связь между классом и его именем в виде строки
  def self.post_types
    { 'Memo' => Memo, 'Task' => Task, 'Link' => Link }
  end

  # Параметром для метода create теперь является строковое имя нужного класса
  def self.create(type)
    post_types[type].new
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

  def self.find_by_id(id)
    # Если id не передали, мы ничего не ищем, а возвращаем nil
    return if id.nil?

    # Открываем «соединение» с базой SQLite, вызывая метод open класса
    # SQLite3::Database, и сохраняем результат в переменную класса db

    db = SQLite3::Database.open(@sqlite_db)
    # Настройка для объекта db, которая говорит, что результаты из базы должны быть преобразованы в хэш руби.
    db.results_as_hash = true
    # Выполняем наш запрос, вызывая метод execute у объекта db. Он возвращает массив результатов, в нашем случае
    # из одного элемента, т.к. только одна запись в таблице будет соответствовать условию «идентификатор
    # соответствует заданному». Результат сохраняем в переменную result.
    begin
      result = db.execute('SELECT * FROM posts WHERE  rowid = ?', id)
    rescue SQLite3::SQLException => e
      # Если возникла ошибка, пишем об этом пользователю и выводим текст ошибки
      puts "Не удалось выполнить запрос в базе #{@sqlite_db}"
      abort e.message
    end

    # Закрываем соединение с базой. Оно нам больше не нужно, результат запроса у нас сохранен.
    # Обратите внимание, что это аналогично файлам. Важно закрыть соединение с базой как можно скорее,
    # чтобы другие программы могли пользоваться базой.
    db.close

    if result.empty?
      # Если массив результатов пуст, означает, что запись не найдена, надо сообщить об этом пользователю и вернуть nil.
      puts "Такой id #{id} не найден в базе :("
      nil
    else
      # Если массив не пустой, значит пост нашелся и лежит первым элементом.
      result = result[0]

      # Вспомним, какая структура у нашего поста в базе. Хэш в переменной
      # result может выглядеть, например, вот так:
      #
      # {
      #   'type' => 'Memo',
      #   'created_at' => '2015-07-26 15:38:26 +0300',
      #   'text' => 'Удачи в прохождении курса!',
      #   'url' => nil,
      #   'due_date' => nil
      # }
      #
      # Самое главное для нас — значение ключа type, т.к. именно там лежит название класса, который нам нужно создать.
      # Создаем с помощью нашего же метода create экземпляр поста, передавая тип поста из ключа массива
      post = create(result['type'])

      # Теперь, когда мы создали экземпляр нужного класса, заполним его содержимым, передав методу load_data хэш result.
      # Обратите внимание, что каждый из детей класса Post сам знает, как ему быть с такими данными.
      post.load_data(result)
      post
    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@sqlite_db)
    # Ищем все посты указанного типа (если в метод передали переменную type). Но для начала скажем нашему объекту
    # соединения, что результаты не нужно преобразовывать к хэшу.
    db.results_as_hash = false

    # Формируем запрос в базу с нужными условиями: начнем с того, что нам
    # нужны все посты, включая идентификатор из таблицы posts.
    query = 'SELECT rowid, * FROM posts '

    # Если задан тип постов, надо добавить условие на значение поля type
    query += 'WHERE type = :type ' unless type.nil?

    # Сортировка — самые свежие в начале
    query += 'ORDER by rowid DESC '

    # Если задано ограничение на количество постов, добавляем условие LIMIT в самом конце
    query += 'LIMIT :limit ' unless limit.nil?

    begin
      # Готовим запрос в базу
      statement = db.prepare query
    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{@sqlite_db}"
      abort e.message
    end

    # Загружаем в запрос тип вместо плейсхолдера :type
    statement.bind_param('type', type) unless type.nil?

    # Загружаем лимит вместо плейсхолдера :limit
    statement.bind_param('limit', limit) unless limit.nil?

    # Выполняем запрос и записываем его в переменную result. Там будет массив с данными из базы.
    # Перед запросом поставим конструкцию begin, чтобы поймать возможные ошибки например, если в базе нет таблицы posts.
    begin
      result = statement.execute!
    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{@sqlite_db}"
      abort e.message
    end

    statement.close

    db.close

    result
  end

  def load_data(data_hash)
    # Общее для всех детей класса Post поведение описано в методе экземпляра класса Post.
    @created_at = Time.parse(data_hash['created_at'])
    @text = data_hash['text']
    # Остальные специфичные переменные должны заполнить дочерние классы в своих
    # версиях метода load_data (вызвав текущий метод с пом. super)
  end

  def read_from_console
    # Этот метод должен быть реализован у каждого ребенка
  end

  def save_to_db
    db = SQLite3::Database.open(@sqlite_db)
    db.results_as_hash = true

    db.execute('INSERT INTO posts (' + to_db_hash.keys.join(', ') + ')' +
                 'VALUES (' + ('?,' * to_db_hash.keys.size).chomp(',') + ')', to_db_hash.values)

    insert_row_id = db.last_insert_row_id

    db.close

    insert_row_id
  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  def to_strings
    # Этот метод должен быть реализован у каждого ребенка
  end
end
