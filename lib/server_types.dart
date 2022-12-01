class ServerTypes {
  static final app = 'app';
  static final web = 'web';
  static final loadBalancer = 'loadbalancer';
  static final cache = 'cache';
  static final database = 'database';
  static final worker = 'worker';
  static final meilisearch = 'meilisearch';
  static final serverTypes = [
    app,
    web,
    loadBalancer,
    cache,
    database,
    worker,
    meilisearch,
  ];

  static final hasSites = [app, web, worker];
  static final hasNoSites = [
    database,
    cache,
  ];
  static final hasPhp = [app, web, worker];
  static final hasNginx = [app, web, loadBalancer,meilisearch];
  static final hasDatabase = [app, database];
  static final hasRedis = [app, cache];
  static final hasMemcached = [app, cache,meilisearch];


}
