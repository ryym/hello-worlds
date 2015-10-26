import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';
import {makeHTTPDriver} from '@cycle/http';

function main(responses) {
  const USERS_URL = 'http://jsonplaceholder.typicode.com/users/';

  // Create the GET request stream.
  let getRandomUser$ = responses.DOM.select('.get-random').events('click')
    .map(() => {
      let randomNum = Math.round( Math.random() * 9 ) + 1;
      return {
        url: USERS_URL + String(randomNum),
        method: 'GET'
      };
    });

  // Create the response stream.
  let user$ = responses.HTTP
    .filter(res$ => res$.request.url.indexOf(USERS_URL) === 0)
    .mergeAll()
    .map(res => res.body)
    .startWith(null);

  // Create the DOM stream which renders the view
  // when the http response come in.
  let vtree$ = user$.map(user => {
    return h('div.users', [
      h('h1.title', 'Random User Example'),
      h('button.get-random', 'Get random user'),
      user === null ? null : h('div.user-details', [
        h('h2.user-name', user.name),
        h('h4.user-email', user.email),
        h('a.user-website', { href: user.website }, user.website)
      ])
    ])
  });

  return {
    DOM: vtree$,
    HTTP: getRandomUser$
  };
}

export default function run() {
  Cycle.run(main, {
    DOM: makeDOMDriver('#randomUser'),
    HTTP: makeHTTPDriver()
  });
}
