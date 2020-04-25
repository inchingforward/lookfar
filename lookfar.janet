(import halo)

(defn handler [request]
  {:status 200 :body "Hello" :headers {"Content-Type" "text/plain"}})

(halo/server handler 8080)