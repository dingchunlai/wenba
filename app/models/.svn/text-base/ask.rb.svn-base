require 'mysql'

class Ask
  def self.get_connection(host, username, password, db, port=3306)
    connection = Mysql.init
    connection.options(Mysql::SET_CHARSET_NAME, 'utf8')
    connection = Mysql.real_connect(host, username, password, db, port)
    connection.query("SET NAMES utf8")
    return connection
  end
  
  def self.get_count_by_sql(connection, sql)
    result = connection.query(sql)
    count = result.num_rows
    return count
  end

  def self.get_results_by_sql(connection, sql)
    results = connection.query(sql)
    return results
  end

  def self.update_or_delete_results_by_sql(connection, sql)
    connection.query(sql)
  end
  
  def self.insert_data_to_ask_db(param_title, param_description, param_answer, param_tags, param_editor_id)
    db_config = YAML.load(File.open("config/database.yml"))
    host = db_config["#{ENV['RAILS_ENV']}"]["host"].to_s
    username = db_config["#{ENV['RAILS_ENV']}"]["username"].to_s
    password = db_config["#{ENV['RAILS_ENV']}"]["password"].to_s
    database = db_config["#{ENV['RAILS_ENV']}"]["database"].to_s
    port = db_config["#{ENV['RAILS_ENV']}"]["port"].to_i
    
    #    conn = get_connection("localhost", "root", "123456", "51hejia")
    conn = get_connection(host, username, password, database, port)

    conn.query("SET AUTOCOMMIT=0")
    conn.query("BEGIN")
  
    #  query ask_zhidao_topic
    sql_query_ask_zhidao_topic = "select id from ask_zhidao_topics where area_id = 1 and method = 2 and subject = \"#{param_title}\""
    @zhidao_topic_count = get_count_by_sql(conn, sql_query_ask_zhidao_topic)
  
    if @zhidao_topic_count == 0
      #    该问答不存在
      #  insert table ask_zhidao_topics
      sql_insert_zhidao_topic = "insert into ask_zhidao_topics(area_id, method, editor_id, subject, description, created_at, updated_at) values "
      sql_insert_zhidao_topic = sql_insert_zhidao_topic + "(1, 2, #{param_editor_id}, \"#{param_title}\", \"#{param_description}\", now(), now())"
      puts sql_insert_zhidao_topic
      update_or_delete_results_by_sql(conn, sql_insert_zhidao_topic)
  
      sql_zhidao_topic_id = "select max(id) as id from ask_zhidao_topics where area_id = 1 and method = 2 and subject = \"#{param_title}\""
      res1 = get_results_by_sql(conn, sql_zhidao_topic_id)
      res1.each_hash { |hash| @zhidao_topic_id = hash["id"].to_i}
  
      #  insert table ask_zhidao_topic_posts
      sql_insert_zhidao_topic_post = "insert into ask_zhidao_topic_posts (method, editor_id, zhidao_topic_id, content, created_at, updated_at) values "
      sql_insert_zhidao_topic_post = sql_insert_zhidao_topic_post + "(2, #{param_editor_id}, #{@zhidao_topic_id}, \"#{param_answer}\", now(), now())"
      puts sql_insert_zhidao_topic_post
      update_or_delete_results_by_sql(conn, sql_insert_zhidao_topic_post)
      
      sql_zhidao_topic_post_id = "select max(id) as id from ask_zhidao_topic_posts where method = 2 and editor_id = #{param_editor_id} and zhidao_topic_id = #{@zhidao_topic_id}"
      res2 = get_results_by_sql(conn, sql_zhidao_topic_post_id)
      res2.each_hash { |hash| @zhidao_topic_post_id = hash["id"].to_i}
  
      #  update table ask_zhidao_topics
      sql_update_zhidao_topic = "update ask_zhidao_topics "
      sql_update_zhidao_topic = sql_update_zhidao_topic + "set post_counter = post_counter + 1, best_post_id = #{@zhidao_topic_post_id} "
      sql_update_zhidao_topic = sql_update_zhidao_topic + "where id = #{@zhidao_topic_id}"
      puts sql_update_zhidao_topic
      update_or_delete_results_by_sql(conn, sql_update_zhidao_topic)
  
      param_tags.gsub("，", ",").split(",").collect{ |s| 
        tag = s.gsub(" ", "")
        #    puts tag
        
        sql_query_user_tag = "select id from ask_user_tags where name = \"#{tag}\""
        @user_tag_count = get_count_by_sql(conn, sql_query_user_tag)
    
        if @user_tag_count == 0
          #  insert table ask_user_tags
          sql_insert_user_tag = "insert into ask_user_tags (name, created_at, updated_at) values (\"#{tag}\", now(), now())"
          puts sql_insert_user_tag
          update_or_delete_results_by_sql(conn, sql_insert_user_tag)
        else
          #        该标签已存在
        end
    
        sql_user_tag_id = "select id from ask_user_tags where name = \"#{tag}\""
        res3 = get_results_by_sql(conn, sql_user_tag_id)
        res3.each_hash { |hash| @user_tag_id = hash["id"].to_i}
  
        #  insert table ask_topic_user_tags
        sql_insert_topic_user_tag = "insert into ask_topic_user_tags (topic_type_id, topic_id, editor_id, user_tag_id, created_at, updated_at) values "
        sql_insert_topic_user_tag = sql_insert_topic_user_tag + "(1, #{@zhidao_topic_id}, #{param_editor_id}, #{@user_tag_id}, now(), now())"
        puts sql_insert_topic_user_tag
        update_or_delete_results_by_sql(conn, sql_insert_topic_user_tag)
      }
    else
      #    该问答已存在
      sql_zhidao_topic_id = "select max(id) as id from ask_zhidao_topics where area_id = 1 and method = 2 and subject = \"#{param_title}\""
      res1 = get_results_by_sql(conn, sql_zhidao_topic_id)
      res1.each_hash { |hash| @zhidao_topic_id = hash["id"].to_i}
    
      #    更新问题--editor_id, description
      #  update table ask_zhidao_topics
      sql_update_zhidao_topic = "update ask_zhidao_topics "
      sql_update_zhidao_topic = sql_update_zhidao_topic + "set editor_id = #{param_editor_id}, description = \"#{param_description}\" "
      sql_update_zhidao_topic = sql_update_zhidao_topic + "where id = #{@zhidao_topic_id}"
      puts sql_update_zhidao_topic
      update_or_delete_results_by_sql(conn, sql_update_zhidao_topic)
  
      #    更新回答--editor_id, content
      #  update table ask_zhidao_topic_posts  
      sql_update_zhidao_topic_post = "update ask_zhidao_topic_posts "
      sql_update_zhidao_topic_post = sql_update_zhidao_topic_post + "set editor_id = #{param_editor_id}, content = \"#{param_answer}\" "
      sql_update_zhidao_topic_post = sql_update_zhidao_topic_post + "where zhidao_topic_id = #{@zhidao_topic_id}"
      puts sql_update_zhidao_topic_post
      update_or_delete_results_by_sql(conn, sql_update_zhidao_topic_post)
  
      #    更新标签
      #  清除ask_topic_user_tags
      #  delete table ask_topic_user_tags
      sql_delete_topic_user_tag = "delete from ask_topic_user_tags where topic_type_id = 1 and topic_id = #{@zhidao_topic_id}"
      puts sql_delete_topic_user_tag
      update_or_delete_results_by_sql(conn, sql_delete_topic_user_tag)
  
      param_tags.gsub("，", ",").split(",").collect{ |s| 
        tag = s.gsub(" ", "")
        #    puts tag
      
        sql_query_user_tag = "select id from ask_user_tags where name = \"#{tag}\""
        @user_tag_count = get_count_by_sql(conn, sql_query_user_tag)
      
        if @user_tag_count == 0
          #  insert table ask_user_tags
          sql_insert_user_tag = "insert into ask_user_tags (name, created_at, updated_at) values (\"#{tag}\", now(), now())"
          puts sql_insert_user_tag
          update_or_delete_results_by_sql(conn, sql_insert_user_tag)
        else
          #        该标签已存在
        end
    
        sql_user_tag_id = "select id from ask_user_tags where name = \"#{tag}\""
        res3 = get_results_by_sql(conn, sql_user_tag_id)
        res3.each_hash { |hash| @user_tag_id = hash["id"].to_i}
  
        #  insert table ask_topic_user_tags
        sql_insert_topic_user_tag = "insert into ask_topic_user_tags (topic_type_id, topic_id, editor_id, user_tag_id, created_at, updated_at) values "
        sql_insert_topic_user_tag = sql_insert_topic_user_tag + "(1, #{@zhidao_topic_id}, #{param_editor_id}, #{@user_tag_id}, now(), now())"
        puts sql_insert_topic_user_tag
        update_or_delete_results_by_sql(conn, sql_insert_topic_user_tag)
      }
    end
  
    conn.query("COMMIT")
    conn.close
  end
end