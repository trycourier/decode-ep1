const Courier = require('@trycourier/courier')

const courier = Courier.CourierClient({ authorizationToken: "pk_prod_4XPS5PVFEBM48RQCXTK4P0BH1CXJ" });

async function test() {

  const { requestId } = await courier.send({
    message: {
      to: {
        user_id: "decode_user",
      },
      content: {
        title: "Hey!",
        body: "How are you?",
      },
      routing: {
        method: "single",
        channels: ["firebase-fcm"],
      },
    },
  });

  console.log(requestId)

}

test()