get '/task' do
  haml :task
end

post '/task' do
  task = Nebula::Task.new(params[:task][:summary], params[:task][:description])
  task.save conversation
end
