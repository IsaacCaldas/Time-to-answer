module SiteHelper

  def msg_jumbotron
    
    case params[:action]

    when 'index'
      "Últimas perguntas cadastradas"
    when 'questions'
      "Resultados para \"#{params[:term]}\""
    when 'subject'
      "Mostrandos questões para o assunto \"#{params[:subject]}\""
    end  
  end

end