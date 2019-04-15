<template>
  <div id="app">

    <section class="main-navbar-section">
      <div class="container">
        <vue-navigation-bar :options="navbarOptions">

          <!-- Custom Slot -->


        </vue-navigation-bar>
      </div>
    </section>

    <div class="container py-4">
      <div class="row justify-content-center">
        <div class="col-lg-12 text-center">
          <h1><strong>Bookpack</strong></h1>
        </div>
      </div>
    </div>



    <div class="container py-2">
      <div class="row justify-content-center">
        <div class="col-lg-10">
          <hr>
        </div>
      </div>
    </div>



  </div>
</template>

<script>

  export default {
    name: 'app',
    data () {
      return {
        navbarOptions: {
          elementId: 'main-navbar',
          isUsingVueRouter: true,
          mobileBreakpoint: 992,
          brandImagePath: './',
          brandImage: require('./src/assets/images/tbp_icon.png'),
          brandImageAltText: 'vnb',
          collapseButtonStyle: 'dark',
          showBrandImageInMobilePopup: true,
          ariaLabelMainNav: 'Main Navigation',
          menuOptionsLeft: [
            {
              type: 'link',
              text: 'Information',
              iconLeft: '<i class="fa fa-star fa-fw"></i>',
              subMenuOptions: [
                {
                  type: 'link',
                  text: 'About',
                  subText: 'Analyze your timeline on Twitter and shows books which you may like.',
                  path: '#',
                  iconLeft: '<svg id="i-info" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32" fill="none" stroke="currentcolor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"> <path d="M16 14 L16 23 M16 8 L16 10" /> <circle cx="16" cy="16" r="14" /> </svg>',
                },
                {
                  type: 'hr',
                },
                {
                  type: 'link',
                  text: 'Merits',
                  subText: 'You can come across favorite books you never thought.',
                  path: '#',
                },
                {
                  type: 'hr',
                },
                {
                  type: 'link',
                  text: 'How To Use',
                  subText: 'Just allow this app to link up your Twitter account',
                  path: '#',
                },
              ]
            },
            {
              type: 'link',
              text: 'Contact',
              subMenuOptions: [
                {
                  type: 'link',
                  text: 'Twitter',
                  subText: 'Twitter Contact details are below of this page. Check it out by scrolling.',
                  path: ''
                },

                {
                  type: 'hr',
                },
                {
                  type: 'link',
                  text: 'Blog',
                  path: '',
                  subText: 'My Managing Blog link is set below of this page. Check it out.',
                  iconLeft: '<svg id="i-telephone" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32" fill="none" stroke="currentcolor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"> <path d="M3 12 C3 5 10 5 16 5 22 5 29 5 29 12 29 20 22 11 22 11 L10 11 C10 11 3 20 3 12 Z M11 14 C11 14 6 19 6 28 L26 28 C26 19 21 14 21 14 L11 14 Z" /> <circle cx="16" cy="21" r="4" /> </svg>',
                },
              ]
            }
          ],
          menuOptionsRight: [

            {
              type: 'button',
              text: 'Login',
              path: './login',
              iconRight: '<svg id="i-arrow-right" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32" fill="none" stroke="currentcolor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"> <path d="M22 6 L30 16 22 26 M30 16 L2 16" /> </svg>'
            }
          ]
        }
      }
    }
  }
</script>

<style lang="scss">
  @import url('https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css');
  @import url('https://fonts.googleapis.com/css?family=Montserrat:400,500,700');

  html {
    width: 100%;
    font-size: 18px;
    color: #333;
  }

  body {
    margin: 0;
    height: 100%;
    height: 100vh;
    width: 100%;
    font-family: 'Montserrat', sans-serif;
  }

  #app {
    height: 100%;
    height: 100vh;
    width: 100%;
    line-height: 1.5;
  }

  .code-text {
    background: #eee;
    border: 1px solid #ddd;
    padding: 10px 20px;
    border-radius: 4px;
    margin-bottom: 20px;
    text-align: center;
  }

  @media (min-width: 992px) {
    .code-text {
      margin-bottom: 0;
    }
  }

  .btn {
    text-transform: uppercase;
    font-weight: bold;
  }

  .github-corner:hover .octo-arm {
    animation:octocat-wave 560ms ease-in-out
  }
  @keyframes octocat-wave {
    0%,100% {transform:rotate(0)}
    20%,60% {transform:rotate(-25deg)}
    40%,80% {transform:rotate(10deg)}
  }
  @media (max-width:500px) {
    .github-corner:hover .octo-arm {animation:none}
    .github-corner .octo-arm {animation:octocat-wave 560ms ease-in-out}
  }

  //
  // vue-navigation-bar customization below
  //

  .main-navbar-section {
    background: #eee;
  }

  .vnb {
    font-family: 'Montserrat', sans-serif;

    .button-red {
      background: #FF3B30;

      &:hover {
        background: darken(#FF3B30, 10%);
      }
    }

    &__menu-options {
      &__option {
        &__button {
          &__icon {
            svg {
              margin-top: -3px;
            }
          }
        }
      }
    }

    &__popup {
      &__bottom {
        &__menu-options {
          &__option {
            &__link {
              &__icon {
                svg {
                  margin-top: -4px;
                }
              }
            }
          }
        }
      }
    }

    .custom-section-content {
      width: 100%;

      @media (min-width: 568px) {
        width: 50%;
      }

      @media (min-width: 992px) {
        width: 15%;
      }

      @media (min-width: 1200px) {
        width: 20%;
      }
    }
  }
</style>
