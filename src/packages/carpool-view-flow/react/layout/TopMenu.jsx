import React from 'react'
import PersonIcon from 'material-ui/lib/svg-icons/social/person'
import AboutIcon from 'material-ui/lib/svg-icons/action/help'
import LeftNav from 'material-ui/lib/left-nav'
import Avatar from 'material-ui/lib/avatar'
import BackIcon from 'material-ui/lib/svg-icons/navigation/arrow-back'
import MenuIcon from 'material-ui/lib/svg-icons/navigation/menu'
import NotificationsIcon from 'material-ui/lib/svg-icons/social/notifications'
import Paper from 'material-ui/lib/paper'
import FlatButton from 'material-ui/lib/flat-button'
import { config } from '../config'

export default class TopMenu extends React.Component {

  constructor (props) {
    super(props)
    this.state = {
      menuOpen: false,
    }
  }

  render () {
    return (
      <Paper
        style={{
          position: 'fixed',
          top: 0,
          height: 50,
          width: window.innerWidth,
          background: config.colors.main,
          zIndex: 1,
          color: 'white',
          borderRadius: 0,
        }}
        zDepth={this.props.hasTopTabs ? 0 : 1}
      >
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'center',
          height: '100%',
        }}>
          <div style ={{
            marginLeft: 12,
          }}>
            {this.props.innerScreen ? (
              <BackIcon color="white" onClick={() => window.history.back()} />
            ) : (
              <MenuIcon color="white" onClick={() => this.setState({ menuOpen: true })} />
            )}
          </div>
          <div style={{
            marginLeft: 12,
            fontSize: 20,
          }}>
            {this.props.title}
          </div>
        </div>
        <LeftNav
          open={this.state.menuOpen}
          onRequestChange={(menuOpen) => this.setState({ menuOpen })}
          docked={false}
        >
          <div style={{
            display: 'flex',
            flexDirection: 'column',
          }}>
            <div style={{
              width: '100%',
              background: 'lightblue',
              paddingTop: 20,
              paddingBottom: 10
            }}>
              <Avatar src="http://lorempixel.com/200/200/people/0" size={60} style={{marginLeft: 10}} />
              <div style={{marginLeft: 17, marginTop: 3}}>
                Name
              </div>
            </div>
            <div style={{marginTop: 2, width: '100%'}}>
              <FlatButton style={{width: '100%', textAlign: 'left'}} label="Profile" icon={<PersonIcon />}
                onClick={() => muiControllerHelper.goToView('Profile')}
              />
            </div>
            <div style={{width: '100%'}}>
              <FlatButton style={{width: '100%', textAlign: 'left'}} label="Notifications" icon={<NotificationsIcon />}
                onClick={() => muiControllerHelper.goToView('NotificationSettings')}
              />
            </div>
            <div style={{width: '100%'}}>
              <FlatButton style={{width: '100%', textAlign: 'left'}} label="About" icon={<AboutIcon />}
                onClick={() => muiControllerHelper.goToView('About')}
              />
            </div>
          </div>
        </LeftNav>
      </Paper>
    )
  }
}