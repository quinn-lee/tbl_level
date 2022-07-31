class HomeController < ApplicationController
  def index
    
  end

  def calc
  	begin
  		@result = {status:"succ"}
  		if params[:c4].blank?
  			raise "请填写补体C4数值"
  		else
  			raise "C4数值在0~0.65之间" if (BigDecimal(params[:c4].to_s) < BigDecimal("0")) or (BigDecimal(params[:c4].to_s) > BigDecimal("0.65"))
  		end
  		if params[:gp73].blank?
  			raise "请填写高尔基体膜蛋白GP-73数值"
  		else
  			raise "GP-73数值在0~350之间" if (BigDecimal(params[:gp73].to_s) < BigDecimal("0")) or (BigDecimal(params[:gp73].to_s) > BigDecimal("350"))
  		end
  		if params[:swe].blank?
  			raise "请填写肝硬度swe数值"
  		else
  			raise "swe数值在0~35之间" if (BigDecimal(params[:swe].to_s) < BigDecimal("0")) or (BigDecimal(params[:swe].to_s) > BigDecimal("35"))
  		end
  		sum = BigDecimal("0")
  		sp = BigDecimal(params[:sp].to_s)
  		c4 = ((BigDecimal("0.65") - BigDecimal(params[:c4].to_s)) / BigDecimal("0.65")) * BigDecimal("40")
  		gp73 = (BigDecimal(params[:gp73].to_s) / BigDecimal("350")) * BigDecimal("50")
  		swe = (BigDecimal(params[:swe].to_s) / BigDecimal("35")) * BigDecimal("100")
  		sum = sp + c4 + gp73 + swe
  		probability = BigDecimal("1")
  		if sum >= BigDecimal("50") && sum < BigDecimal("70")
  			probability = ((sum - BigDecimal("50")) / BigDecimal("20")) * BigDecimal("4") + BigDecimal("1")
  		elsif sum >= BigDecimal("70") && sum < BigDecimal("84")
  			probability = ((sum - BigDecimal("70")) / BigDecimal("14")) * BigDecimal("15") + BigDecimal("5")
  		elsif sum >= BigDecimal("84") && sum < BigDecimal("92")
  			probability = ((sum - BigDecimal("84")) / BigDecimal("8")) * BigDecimal("20") + BigDecimal("20")
  		elsif sum >= BigDecimal("92") && sum < BigDecimal("100")
  			probability = ((sum - BigDecimal("92")) / BigDecimal("8")) * BigDecimal("20") + BigDecimal("40")
  		elsif sum >= BigDecimal("100") && sum < BigDecimal("112")
  			probability = ((sum - BigDecimal("100")) / BigDecimal("12")) * BigDecimal("20") + BigDecimal("60")
  		elsif sum >= BigDecimal("112") && sum < BigDecimal("128")
  			probability = ((sum - BigDecimal("112")) / BigDecimal("16")) * BigDecimal("15") + BigDecimal("80")
  		elsif sum >= BigDecimal("128") && sum < BigDecimal("144")
  			probability = ((sum - BigDecimal("128")) / BigDecimal("16")) * BigDecimal("4") + BigDecimal("95")
  		elsif sum >= BigDecimal("144") && sum < BigDecimal("164")
  			probability = ((sum - BigDecimal("144")) / BigDecimal("20")) * BigDecimal("0.9") + BigDecimal("99")
  		elsif sum >= BigDecimal("164")
  			probability = 99.99
  		end
  		if probability < 25
  			level = 1
  		elsif probability < 50
  			level = 2
  		elsif probability < 75
  			level = 3
  		else
  			level = 4
  		end
  		@result = {status:"succ" , probability: sprintf("%.2f", probability), level: level}
  	rescue=>e
  		@result = {status:"fail" ,message: e.message}
  	end
  	respond_to { |f| f.js }
  end
end
