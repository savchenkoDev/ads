class AdParamsContract < Dry::Validation::Contract
  params do
    required(:ad).hash do
      required(:title).value(:string)
      required(:description).value(:string)
      required(:city).value(:string)
    end
  end
end
