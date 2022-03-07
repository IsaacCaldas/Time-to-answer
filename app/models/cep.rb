require 'net/http'

class CEP

  attr_reader :logradouro, :bairro, :localidade, :uf
  END_POINT = "https://viacep.com.br/ws"
  FORMAT = 'json'

  def initialize(cep)
    found_cep = find(cep) # hash
    fill(found_cep) 
  end
  
  def address
    "#{@logradouro}, #{@bairro}, #{@localidade} - #{@uf}"
  end

  private

  def find(cep)
    ActiveSupport::JSON.decode(
      Net::HTTP.get(
        URI("#{END_POINT}/#{cep}/#{FORMAT}/")
      )
    )
  end 

  def fill(found_cep)
    @logradouro = found_cep["logradouro"]
    @bairro     = found_cep["bairro"]
    @localidade = found_cep["localidade"]
    @uf         = found_cep["uf"]
  end

end

# CEP.new("11350260")