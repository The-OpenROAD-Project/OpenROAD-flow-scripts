import os
import logging
from naja import snl
from naja.stats import design_stats

def edit():
  post_edit_base_name = 'post_edit'
  if os.getenv('POST_EDIT_BASE_NAME') != None:
    post_edit_base_name = os.getenv('POST_EDIT_BASE_NAME')
  log_name = post_edit_base_name + '.log'
  logging.basicConfig(filename=log_name, filemode='w' ,level=logging.DEBUG)
  universe = snl.SNLUniverse.get()
  if universe is None:
    logging.critical('No loaded SNLUniverse')
    return 1
  top = universe.getTopDesign()
  if top is None:
    logging.critical('SNLUniverse does not contain any top SNLDesign')
    return 1
  else:
    logging.info('Found top design ' + str(top))

  #clean_buffer_and_constants(top)
  stats_file_name = post_edit_base_name + '.stats'
  stats = open(stats_file_name, 'w')
  design_stats.compute_and_dump_design_stats(top, stats) 
