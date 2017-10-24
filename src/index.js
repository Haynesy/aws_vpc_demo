const handler = (event, context) {

    console.log("It works!", event);
    context.succeed("Oh yay!");
}

exports.handler = handler;