import json, logging, random, sys
import argparse
import requests

def test_counter(base_url, max_sessions, max_iterations): 
  logging.debug('Creating %s request sessions' % max_sessions)
  sessions_list = [ [index, requests.Session(), 0] for index in range(0, max_sessions) ] 

  logging.debug('Starting %s test iterations...' % max_iterations)
  for iter in range(0, max_iterations): 
    session = random.choice(sessions_list)
    current_count = session[2]

    response = session[1].get(base_url + '/counter')
    response_count = response.json().get('counter')

    if response_count == (current_count + 1): 
      session[2] = current_count + 1
    else: 
      logging.error('CACHEMISS: session #%s at iteration #%s (current_count = %s, response_count = %s)' % (session[0], iter, current_count, response_count))
      session[2] = response_count

  logging.info('Final sessions_list: %s' % (sessions_list))


if __name__ == "__main__":

  # parse cli options
  cliparser = argparse.ArgumentParser(
    description = 'Runs a test of stateful Flask webapp deployed on ECS' 
  )
  cliparser.add_argument('--debug', 
    required=False, 
    action='store_true', 
    help='enables debug logging mode'
  )
  cliparser.add_argument('--base-url', 
    required=True, 
    help='base url of webapp (e.g. http://example.aws:8080)'
  )
  cliparser.add_argument('--max-sessions', 
    required=False, 
    default=10, 
    help='maximum number of concurrent sessions to launch (default is 10)'
  )
  cliparser.add_argument('--max-iterations',  
    required=False, 
    default=100, 
    help='maximum number of test iterations of run (default is 100)'
  )

  # extract cli option values and set program behavior
  args = cliparser.parse_args()

  # configure logger
  log_level = logging.INFO
  if args.debug: log_level = logging.DEBUG
  logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level = log_level)

  test_counter(args.base_url, args.max_sessions, args.max_iterations)