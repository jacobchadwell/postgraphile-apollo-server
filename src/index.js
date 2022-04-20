const pg = require("pg");
const { ApolloServer } = require("apollo-server");
const { makeSchemaAndPlugin } = require("postgraphile-apollo-server");
const pgSimplifyInflectorPlugin = require("@graphile-contrib/pg-simplify-inflector");
const pgManyToManyPlugin = require("@graphile-contrib/pg-many-to-many");
const pgConnectionFilterPlugin = require("postgraphile-plugin-connection-filter");
const makeWrapResolversPlugin = require("graphile-utils");
const { wrapSchema, FilterTypes } = require("@graphql-tools/wrap");

const pgPool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});

// TODO: break out into a config file
const postgraphileOptions = {
  subscriptions: true,
  watchPg: true,
  dynamicJson: true,
  setofFunctionsContainNulls: false,
  ignoreRBAC: false,
  showErrorStack: "json",
  extendedErrors: ["hint", "detail", "errcode"],
  appendPlugins: [
    pgSimplifyInflectorPlugin,
    pgManyToManyPlugin,
    pgConnectionFilterPlugin,
    makeWrapResolversPlugin
  ],
  exportGqlSchemaPath: "schema.graphql",
  graphiql: true,
  enhanceGraphiql: true,
  // allowExplain(req) {
  //   // TODO: customise condition!
  //   return true;
  // },
  enableQueryBatching: true,
  legacyRelations: "omit",
  // pgSettings(req) {
  //   /* TODO */
  // },
};

async function main() {
  const { schema, plugin } = await makeSchemaAndPlugin(
    pgPool,
    "public", // PostgreSQL schema to use
    {
      ...postgraphileOptions,
    }
  );

  const wrappedSchema = wrapSchema({
    schema: schema,
    transforms: [
      new FilterTypes((name) => {
        let tmp = name.toString();
        if (
          tmp.startsWith("Edge") ||
          tmp.startsWith("CreateEdge") ||
          tmp.startsWith("UpdateEdge") ||
          tmp.startsWith("DeleteEdge")
        ) {
          return false;
        }
        return true;
      }),
    ],
  });

  const server = new ApolloServer({
    schema: wrappedSchema,
    plugins: [plugin],
  });

  const { url } = await server.listen();
  console.log(`🚀 Server ready at ${url}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
