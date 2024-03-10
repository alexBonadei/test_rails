# README

## Setup:

```bash
bundle install
yarn install

rails db:create db:migrate
rails db:seed
```

Per avviare il server:
```bash
rails server
bin/webpack-dev-server
```

Per avviare i test:

```bash
rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test
bundle exec rspec
```

### Compiti:

a) L'api corrente /api/posts ha un problema di performance molto comune. Qual è? Come si potrebbe risolvere?

Il problema che ho notato nell'API è l'elevato numero di chiamate al db. Il problema nasce dal fatto che viene fatta una chiamata alla collezione `posts`. Ogni elemento contiene un array di `tags` per la quale deve essere fatto il join/lookup per risolvere il nome.
Questa lookup viene fatta ciclando sull'array di posts. Perciò, ponendo come N il numero di post, vengono fatte N + 1 chiamate al db (N + 1 Queries Problem).

Questa operazione può essere svolta facendo solamente 2 query al db. La prima fa il fetch dei posts e la seconda fa il fetch dei tags.
La lookup poi potrebbe essere risolta manualmente inserendo i tags in una mappa e ciclando sui post con complessità O(n) e 2 chiamate al db.

Non sono pratico di ruby on rails ma cercando qua e là (https://guides.rubyonrails.org/active_record_querying.html#includes) ho scoperto che il framework permette di fare questa operazione con una sintassi molto pulita, senza dover modificare la restante parte del codice:
```ruby
@posts = Post.includes(:tags).all
```

b) Implementare una nuova API nel PostsController che, ricevendo in GET un parametro "term" permetta di cercare per nome e per tag i post.

Ad esempio, cercando "gatto", verrà trovato un post che contiene la parola gatto o che ha almeno un tag che si chiama "gatto".

Per l'implementazione, utilizzare l'approccio "TDD". Per farla semplice, implementa semplicemente un test nella cartella spec/requests similare a quello già fatto per l'index

c) Implementare in Vue un'input form, modificando il componente app.vue, che permetta di filtrare i post utilizzando l'API creata precedentemente.
