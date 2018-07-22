ActiveSupport.halt_callback_chains_on_return_false = true

class Cliente < ApplicationRecord
  before_save :validation?

  belongs_to :user
  
  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validates :endereco, presence: true

  protected

	def validation?
	  unless check_cpf(self.cpf) 
		   #throw(:abort) 
		   errors.add(:CPF, "Inválido.")
   		 raise ActiveRecord::RecordInvalid.new(self)
	  else
      utility_case
    end
	end

  private

  def utility_case
    self.nome = self.nome.capitalize
    self.email = self.email.downcase
    self.endereco = self.endereco.capitalize
  end

  def check_cpf(cpf=nil)
    return false if cpf.nil?

    nulos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}
    valor = cpf.scan /[0-9]/
    if valor.length == 11
      unless nulos.member?(valor.join)
        valor = valor.collect{|x| x.to_i}
        soma = 10*valor[0]+9*valor[1]+8*valor[2]+7*valor[3]+6*valor[4]+5*valor[5]+4*valor[6]+3*valor[7]+2*valor[8]
        soma = soma - (11 * (soma/11))
        resultado1 = (soma == 0 or soma == 1) ? 0 : 11 - soma
        if resultado1 == valor[9]
          soma = valor[0]*11+valor[1]*10+valor[2]*9+valor[3]*8+valor[4]*7+valor[5]*6+valor[6]*5+valor[7]*4+valor[8]*3+valor[9]*2
          soma = soma - (11 * (soma/11))
          resultado2 = (soma == 0 or soma == 1) ? 0 : 11 - soma
          return true if resultado2 == valor[10] # CPF válido
        end
      end
    end
    return false # CPF inválido
  end

end
