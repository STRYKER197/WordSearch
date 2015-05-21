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
#import "AppDelegate.h"
#import "Score.h"
@import CoreData;

#define qtd 15

@interface MapaViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

int counter = 0;
NSArray *paisesArray;
NSString *paisSearch;
CLGeocoder *ceo;
CLLocation *loc;
NSMutableArray *numerosSorteados;
NSTimer *myTimer;

NSTimer *timer;
double timerInterval = 20.0;
double timerElapsed = 0.0;
NSDate *timerStarted;

@implementation MapaViewController
@synthesize lblPoint, lblTime, lblPais, mapKit;

- (void)viewDidLoad {
    [super viewDidLoad];
    //CoreData
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = appDelegate.managedObjectContext;

    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //Define o idioma dos paises do jogo.
    if ([language isEqualToString:@"pt"]) {
        paisesArray = @[@"Brasil", @"Estados Unidos da América", @"Argentina", @"Uruguai", @"Austrália", @"Islândia", @"França", @"Espanha", @"Irlanda", @"Rússia", @"Argélia", @"África Do Sul", @"Madagascar", @"Índia", @"Japão", @"China", @"Finlândia", @"Noruega", @"Groenlândia", @"Canadá"];
    } else {
        paisesArray = @[@"Brazil", @"United States", @"Argentina", @"Uruguay", @"Australia" ,@"Iceland", @"France", @"Spain", @"Ireland", @"Russia", @"Algeria", @"South Africa", @"Madagascar", @"India", @"Japan", @"China", @"Finland", @"Norway", @"Greenland", @"Canada"];
    }
    
    
    UILongPressGestureRecognizer *toqueLongo = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(adicionarPino:)];
    toqueLongo.minimumPressDuration = 0.2;
    [mapKit addGestureRecognizer:toqueLongo];
    
    //Inicia o GeoCoder
    ceo = [[CLGeocoder alloc]init];
    loc = [[CLLocation alloc]initWithLatitude:32.00 longitude:21.322]; //insert your coordinatesz

    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  NSLog(@"Iniciando GeoCoder");
              
              }];
    //Inicia o jogo
    [self iniciarJogo];
 
    //Tipo do mapa
    mapKit.mapType = MKMapTypeStandard;
    mapKit.delegate = self;
    //Idioma do mapa
    

}

- (void) iniciarJogo
{
    int numberRandom = arc4random_uniform(qtd);
    paisSearch = paisesArray[numberRandom];
//    NSString *texto = [NSString stringWithFormat:@"Procure por: %@", paisSearch];
    lblPais.text = paisSearch;
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
//    SCLButton *button = [alert addButton:@"Iniciar Jogo" target:self selector:@selector(comecarJogo)];
    
//    button.buttonFormatBlock = ^NSDictionary* (void)
//    {
//        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
//        
////        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
////        buttonConfig[@"textColor"] = [UIColor blackColor];
////        buttonConfig[@"borderWidth"] = @2.0f;
////        buttonConfig[@"borderColor"] = [UIColor greenColor];
//        
//        return buttonConfig;
//    };
    
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [alert showSuccess:@"World Search" subTitle:@"Divirta-se!!!" closeButtonTitle:@"Começar o jogo" duration:0.0f];
    [alert alertIsDismissed:^{
        [self comecarJogo];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startCountdown:(int)tempoInicial
{
    //Quantidade de segundos do jogo.
    counter = tempoInicial;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decrementTimer:)                                                              userInfo:nil repeats:YES];
}

- (void)decrementTimer:(NSTimer *)timer
{
//    NSLog(@"Teste de Numero: %d", [self gerarNumero]);
    counter = counter - 1;
    lblTime.text = [NSString stringWithFormat:@"%d",counter];
    
    if (counter <= 5) {
        lblTime.textColor = [UIColor redColor];
    } else {
        lblTime.textColor = [UIColor colorWithRed:101.0f/255.0f
                                            green:186.0f/255.0f
                                             blue:105.0f/255.0f
                                            alpha:1.0f];
    }
    //(GAME-OVER) - O TEMPO ACABOU
    if (counter <= 0) {
        [timer invalidate];
        mapKit.userInteractionEnabled = false;
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        [alert alertIsDismissed:^{
            //Alerta de encerramento
        }];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
        NSDate *now = [NSDate date];
        NSString *nsstr = [format stringFromDate:now];
        
        [self save:lblPoint.text data:nsstr];
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
    [self startCountdown:20];
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
    int numberRandom = arc4random_uniform(qtd);
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
            int n = arc4random_uniform(qtd);
        for (int i=0; i<numerosSorteados.count; i++) {
            if (numerosSorteados[i] == [NSDecimalNumber numberWithInt:n]) {
                contador++;
                }
            }
        }
        return n;
    }
}


- (void) save: (NSString *)pontuacao data:(NSString *)data
{
    Score *sc = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:self.managedObjectContext];

    sc.pontuacao = pontuacao;
    sc.data = data;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Erro");
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
                      NSLog(@"Pais: %@",placemark.country);
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
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(removerPino)
                                       userInfo:nil
                                        repeats:NO];

    
    }
}
                     
- (void) removerPino
{
    [mapKit removeAnnotation:[mapKit.annotations lastObject]];
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

- (void)backToMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [myTimer invalidate];
}
- (IBAction)pauseGame:(id)sender {
    
    NSLog(@"Abriu a view customizada!");
    [self pauseTimer];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    SCLButton *button = [alert addButton:@"Quit Game" target:self selector:@selector(backToMenu)];
    
//    [alert addButton:@"Second Button" actionBlock:^(void) {
//        NSLog(@"Second button tapped");
//    }];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    
    [alert showCustom:self image:[UIImage imageNamed:@"gear.png"] color:color title:@"Custom" subTitle:@"Add a custom icon and color for your own type of alert!" closeButtonTitle:@"Cancelar" duration:0.0f];
    
    
    
    [alert alertIsDismissed:^{
        [self startTimer];
//        NSLog(@"Fechou a view customizada");
    }];
}

//MARK: Funções para pausar o jogo
-(void) startTimer {
    [self startCountdown:timerElapsed];
}

-(void) fired {
    [myTimer invalidate];
    myTimer = nil;
//    timerElapsed = 0.0;
    [self startTimer];
    // react to timer event here
}

-(void) pauseTimer {
    [myTimer invalidate];
    myTimer = nil;
    timerElapsed = [lblTime.text doubleValue];
}

@end
