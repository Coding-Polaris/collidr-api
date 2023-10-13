RSpec.shared_examples_for "SaveBroadcaster" do |model|
  let(:model_instance) { build(model) }
  let(:model_instance_fail) { build(model, :invalid) }

  it "broadcasts successful creation" do
    key = "created_#{model}".to_sym
    expect { model_instance.save }.to broadcast(key, model_instance)
  end

  it "broadcasts successful update" do
    model_instance.save
    key = "updated_#{model}".to_sym
    expect { model_instance.save }.to broadcast(key, model_instance)
  end

  it "broadcasts save failure" do
    key = "failed_#{model}".to_sym
    expect { model_instance_fail.save }.to broadcast(key, model_instance_fail)
  end
end