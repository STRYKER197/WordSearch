//
//  MapaViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/8/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "MapaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "CustomAnnotation.h"


@interface MapaViewController ()


@end

int counter = 0;
NSArray *paisesArray;
NSString *paisSearch;
CLGeocoder *ceo;
CLLocation *loc;
NSMutableArray *numerosSorteados;

@implementation MapaViewController
@synthesize lblPoint, lblTime, lblPais, mapKit;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //Define o idioma dos paises do jogo.
    if ([language isEqualToString:@"pt"]) {
        paisesArray = @[@"Brasil", @"Estados Unidos da América", @"Argentina"];
    } else {
        paisesArray = @[@"Brazil", @"United States", @"Argentina"];
    }
    
    UILongPressGestureRecognizer *toqueLongo = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(adicionarPino:)];
    toqueLongo.minimumPressDuration = 0.2;
    [mapKit addGestureRecognizer:toqueLongo];
    
    //Inicia o GeoCoder
    ceo = [[CLGeocoder alloc]init];
    loc = [[CLLocation alloc]initWithLatitude:32.00 longitude:21.322]; //insert your coordinatesz
    
    //Inicia o jogo
    [self iniciarJogo];
 
    //Tipo do mapa
    mapKit.mapType = MKMapTypeStandard;
    mapKit.delegate = self;
}

- (void) iniciarJogo
{
    int numberRandom = arc4random_uniform(2);
    paisSearch = paisesArray[numberRandom];
    NSString *texto = [NSString stringWithFormat:@"Procure por: %@", paisSearch];
    lblPais.text = paisSearch;
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    SCLButton *button = [alert addButton:@"Iniciar Jogo" target:self selector:@selector(comecarJogo)];
    
    button.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
//        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
//        buttonConfig[@"textColor"] = [UIColor blackColor];
//        buttonConfig[@"borderWidth"] = @2.0f;
//        buttonConfig[@"borderColor"] = [UIColor greenColor];
        
        return buttonConfig;
    };
    
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [alert showSuccess:@"World Search" subTitle:@"Ache o pais designado:" closeButtonTitle:@"Sair" duration:0.0f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startCountdown
{
    //Quantidade de segundos do jogo.
    counter = 20;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decrementTimer:)                                                              userInfo:nil repeats:YES];
}

- (void)decrementTimer:(NSTimer *)timer
{
        NSLog(@"Teste de Numero: %d", [self gerarNumero]);
    counter = counter - 1;
    lblTime.text = [NSString stringWithFormat:@"%d",counter];
    //(GAME-OVER) - O TEMPO ACABOU
    if (counter <= 0) {
        [timer invalidate];
        mapKit.userInteractionEnabled = false;
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        [alert alertIsDismissed:^{
            NSLog(@"SCLAlertView dismissed!");
        }];
        NSString *texto = [NSString stringWithFormat:@"Fim de jogo \n Sua pontuação é: %@", lblPoint.text];
        [alert showInfo:self title:@"Game Over" subTitle:texto closeButtonTitle:@"Ok" duration:0.0f];
    }
}

- (void) exibirMensagem:(NSString *)txtMensagem tituloMensagem:(NSString *)titulo tituloBotao:(NSString *)botao
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:txtMensagem delegate:self cancelButtonTitle:nil otherButtonTitles:botao, nil];
    [alert show];
}

- (void) comecarJogo
{
    [self startCountdown];
}


- (void) adicionaPontuacao {
    NSInteger pontuacao = [lblPoint.text integerValue];
    pontuacao = pontuacao + 20;
    lblPoint.text = [NSString stringWithFormat:@"%ld",pontuacao];
}

- (void) proximoPais
{
    counter = 20;
    //Seleciona o proximo pais.
    int numberRandom = arc4random_uniform(3);
    paisSearch = paisesArray[numberRandom];
    lblPais.text = paisSearch;
    
}

- (int) gerarNumero
{
    int n = arc4random_uniform(4);
    
    int contador=0;
    if (numerosSorteados.count == 4) {
        [numerosSorteados removeAllObjects];
    }
    
    if (numerosSorteados.count == 0) {
        [numerosSorteados addObject:[NSDecimalNumber numberWithInt:n]];
        return n;
    } else {
        while (contador > 0) {
            contador = 0;
            int n = arc4random_uniform(2);
        for (int i=0; i<numerosSorteados.count; i++) {
            if (numerosSorteados[i] == [NSDecimalNumber numberWithInt:n]) {
                contador++;
                }
            }
        }
        return n;
    }
}

//MARK: Pinos
- (void) adicionarPino:(UIGestureRecognizer *)gesto {
    if (gesto.state == UIGestureRecognizerStateBegan) {
        CGPoint ponto  = [gesto locationInView:self.view];
        CLLocationCoordinate2D coordenadas = [mapKit convertPoint:ponto toCoordinateFromView:mapKit];
        MKPointAnnotation *pino = [[MKPointAnnotation alloc] init];
        pino.coordinate = coordenadas;

        ceo = [[CLGeocoder alloc]init];
        loc = [[CLLocation alloc]initWithLatitude:pino.coordinate.latitude longitude:pino.coordinate.longitude]; //insert your coordinatesz
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                      NSLog(@"placemark %@",placemark);
                      //String to hold address
//                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
//                      NSLog(@"placemark %@",placemark.region);
//                      NSLog(@"placemark %@",placemark.country);  // Give Country Name
//                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
//                      NSLog(@"location %@",placemark.name);
//                      NSLog(@"location %@",placemark.ocean);
//                      NSLog(@"location %@",placemark.postalCode);
//                      NSLog(@"location %@",placemark.subLocality);
//                      
//                      NSLog(@"location %@",placemark.location);
//                      //Print the location to console
//                      NSLog(@"I am currently at %@",locatedAt);
                      
                      if ([paisSearch isEqualToString:placemark.country]) {
                          [self adicionaPontuacao];
                          NSLog(@"Você Acertou!");
                          [self proximoPais];
                      } else {
                          NSLog(@"Você errou - 5 segundos!, %@", placemark.country);
                          counter = counter - 5;
                      }
                  }
         ];
        [mapKit addAnnotation:pino];
    
    }
}

//MARK: Métodos dos pinos(Annotations)

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapKit dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationViewID"];
    }
    
    annotationView.image = [UIImage imageNamed:@"target.png"];
    annotationView.annotation = annotation;
    
    return annotationView;
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [self.mapKit dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
//    if (!pinView) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
//        
//        //Cor aleatoria de pinos
//        
////        switch (r) {
////            case 1:
////                pinView.pinColor = MKPinAnnotationColorGreen;
////                break;
////            case 2:
////                pinView.pinColor = MKPinAnnotationColorPurple;
////                break;
////            case 3:
////                pinView.pinColor = MKPinAnnotationColorRed;
////                break;
////                
////            default:
////                pinView.pinColor = MKPinAnnotationColorRed;
////                break;
////        }
//        pinView.animatesDrop = YES;
//        pinView.canShowCallout = YES;
//        pinView.image = [UIImage imageNamed:@"acerto.png"];
//        UIButton *btPin = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        pinView.rightCalloutAccessoryView = btPin;
//    } else {
//        //Existe no cache , vamos reaproveitar
//        pinView.annotation = annotation;
//    }
//    return pinView;
//}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
//        CustomAnnotation *myLocation = (CustomAnnotation *)annotation;
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
//        if (annotationView == nil) {
//            annotationView = myLocation.annotationView;
//        } else {
//            annotationView.annotation = annotation;
//        }
//        return annotationView;
//    } else {
//        return nil;
//    }
//}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //Clicou no botão da view
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MapView" message:@"Oppa Gangnam Style" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}


@end
