const Courier = require('@trycourier/courier')

const courier = Courier.CourierClient({ authorizationToken: "your_key" });

async function test() {

  const userId = "decode_user"
  const title = "Hello!"
  const body = "This message was sent from NodeJS"

  const { requestId } = await courier.send({
    message: {
      to: {
        user_id: userId,
      },
      content: {
        title: title,
        body: body,
      },
      routing: {
        method: "single",
        channels: ["firebase-fcm"],
      },
    },
  });

  // Example with custom data
  // const { requestId } = await courier.send({
  //   message: {
  //     to: {
  //       user_id: userId,
  //     },
  //     content: {
  //       title: title,
  //       body: body,
  //     },
  //     routing: {
  //       method: "single",
  //       channels: ["firebase-fcm"],
  //     },
  //     providers: {
  //       "firebase-fcm": {
  //         override: {
  //           body: {
  //             data: {
  //               example_url: "https://docs.courier.com"
  //             }
  //           }
  //         }
  //       }
  //     }
  //   },
  // });

  // https://app.courier.com/designer/notifications/S57FS04HNS4Z4GHJ61RHBS1QT69G/design
  // const { requestId } = await courier.send({
  //   message: {
  //     to: {
  //       user_id: userId,
  //     },
  //     template: "S57FS04HNS4Z4GHJ61RHBS1QT69G",
  //   },
  // });

  console.log(requestId)

}

test()