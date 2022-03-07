module SiteHelper

  def msg_jumbotron
    
    case params[:action]

    when 'index'
      "Últimas perguntas cadastradas"
    when 'questions'
      "Resultados para \"#{sanitize params[:term]}\""
    when 'subject'
      "Mostrandos questões para o assunto \"#{sanitize params[:subject]}\""
    end  
  end

end