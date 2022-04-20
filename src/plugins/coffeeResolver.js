const { makeWrapResolversPlugin } = require("graphile-utils");

const coffeeResolver = () => {
    return async (resolve, source, args, context, resolveInfo) => {
        // Testing custom resolver
        const result = await resolve();
        return result;
    }
}

module.exports =  makeWrapResolversPlugin({
    Query: {
        coffeeTypes: coffeeResolver()
    }
});