class HealthRoute < Roda
  route do |r|
    r.is do
      'OK'
    end
  end
end
