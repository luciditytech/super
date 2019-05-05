class Router < Roda
  route do |r|
    r.on 'health' do
      r.run HealthRoute
    end
  end
end
